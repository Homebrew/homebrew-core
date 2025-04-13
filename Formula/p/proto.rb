class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.47.10.tar.gz"
  sha256 "25e7ad341b7f490ca7a8d2ef7a812a396832413d77120bfaf6e6ffeabb8b1bd9"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee7306939416f5403aafa1e8245f0e965851d5d09a9ce534baa54e3cf3ad7068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d62108be93c4cb55559636ed669377c7be93c7a863be3d237c04a3d58f2dfe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7dacf3922c4aebb0bfb52a827d9405e2b0b84eb0509c605565c31d2d7cd1469"
    sha256 cellar: :any_skip_relocation, sonoma:        "f98ba037ae5f16f4d4072d313688f29e7f2db82b86cf5d62e94e56a43465e05d"
    sha256 cellar: :any_skip_relocation, ventura:       "e0fea9b3c58bf7de88dd6a1c7a354fea09433e26fda385e974d4739785b4b451"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "236f0ab0a6f0e4257db447ef5e9e8ea053f9ab6b962732762c1e04c711c44529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ce9bd40a44d4183aec60abc866e55be1528be380d03b63547d7a73f4ab5c37"
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
