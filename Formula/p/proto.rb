class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "acf4e26be09320cec85437a3b47d6581c4f8d679d3e314e6b87ad212c4a3ca15"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20340914aeca242845ce49bd19eebb4e46560bf7cd7fcbbba35987a4b044fce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1819bd9d20cec25e9a1af1134a6ee51090199aed237f8a0385ab6d2590035bfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a4f9d5961d7797759f599eadf86b5f954b2f28d272fdf8bafad8a5a34e4c7d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d3b78d1e7cf6d61577e97d6c86a6f89335355286cced011eeac565216c1ab0b"
    sha256 cellar: :any_skip_relocation, ventura:       "c4995a9ab875aa0dc0d6d2c18dad95148966c0e7aaf499ab8fe611a57a5bad06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "653f55abd750438afbc9af4b8f6cc6520b7304378fda473fc8a1d20e55f25df3"
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
