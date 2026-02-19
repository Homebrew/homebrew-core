class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.55.2.tar.gz"
  sha256 "a601f2f304db0b0179d200832a1f307e8764ac7e9fd9725e51557ad7e902b7d7"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fccab4d8488468bb09b1595239e58424969efd3b36bcb5734a4804457baaeab6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ac05f35be2af8f3711f0d9b543081eaf4c4609cbd3b9590dffafdd8012d428a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414c05ff10ac3a9fd25a121c12a459370255396c5962e8eb09e6caaa814530a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f15fa31b127891325e0005d39405a7ffa289d9185df015630df9476ecc6f97c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44ec932c32a8efded15fd97586b2a967da2868bff1858cadca61d2230609b2cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a87e5dc2e41f0c92cb9b559d8e96763e88313d1663a095a28e28cf4ab27cbf52"
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
