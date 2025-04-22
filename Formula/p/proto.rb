class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "2a635f102d80d184dfca280216db0a2acf8a2aaafa2fb26ba6179e9ce520b060"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6902844058125b1957e46349c3dbb9abf7e955ed3277437ea8a34b5edc85534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20759a786d1b69714aa2b11378911775a7ed95757729824307f08af449bb93e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72ce00ae760c2d19c5f0cf006b312cb9c310310381ba965f77bff69216989d35"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c3c24617653e8e138b15ba0b5ac6aaf5d0cf9a117f37d9a3b34e30f50b2ebc2"
    sha256 cellar: :any_skip_relocation, ventura:       "a92c63dd1fd453c214a008545057dab2c972445e5813965c8aa4be0739dfb1c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ae2342941195167de0de332532c49f65b80a8fa55191dda6efdd3bcd260e296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad9971261fd7edfac25db78061f749d76242fac842ed3028115d4538b3ba73cc"
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
