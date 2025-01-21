class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.44.7.tar.gz"
  sha256 "28914d4f250f834d6b05c1b6f54550a60c474daaf871727faedca175e030087f"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee5e97d677a1beb725468c7c9ca92b08661d6b1f634f6350c37bc0321911fec7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "502d5263348335820dcc97363c323c596675e6c2a9d14295be46e31c3c018025"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d63a0e0e01d914a6142a2daa5624fc69907299ce3ab0973281be29b04042119"
    sha256 cellar: :any_skip_relocation, sonoma:        "987177603868ca01314020cba44eb5a7a2dbeb2756ffd5e59888bbcf8e7427fc"
    sha256 cellar: :any_skip_relocation, ventura:       "bb4a1f60a1cd57be72edb16119667ee41a0388dc7528791166bf02d8440745ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42cb3f3a851d6e82a36f768ca5fbe8748a54b85e7a9b47cc1b4513b939596cdf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end
