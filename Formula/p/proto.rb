class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "d0045b731e5124b023ab742caae07583f0f498736517cccf3ed83047c51606cc"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43e2f3400444ad210f13f22800efd6377e0a771a263fb76df2eee0997d69b32a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c45d2054e0e83e68efd008f67b90b9bf3046b9307388270d18d3ad35e5828154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7da6ecbd5d2168c3e07f1be5844e0853293dfffcb0e99091bd417b63bb8f7fbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "83d18d32bbe95f3fea468610964bf8c4ac2f97f5f00ec465da7e36e8f040979b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ed28c3865900ee077383b2c9b01a81060e1df62d858a2ee151ba5dbea1b5730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa92d7c2d601c47c1e5b1b6fde475149b661aa034b7f2fca561c754057ddb04d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
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
