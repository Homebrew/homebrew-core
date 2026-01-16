class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.54.1.tar.gz"
  sha256 "95a0f7dc5b5ebd021a59d8845c0b7c9e082482cd8204c9d7ebe80a510c437e34"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f97e902cfa0865f9cd7336e9f00bddcba5ca0840b077f5b8d32e34b3b4e61d87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deff50da15742d47bcffc94fd7cd5167ad5aba45ad2666122090c41fe2b24333"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a66097398547456453192cb7b1f7c89f2116a275dbecc77e492fc1aa3c414084"
    sha256 cellar: :any_skip_relocation, sonoma:        "94dc88a6491380b134de53292fd1f2f4c6e7797ba78c0449ce730179c2bbae25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66cea0c21a2b2d1e9007ed914f9717925f8dddb43f22b7b429f66b236314dba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11520a6180180003a81e1d0c7d679d373480002c4a134fc3534df3f3ef87b782"
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
