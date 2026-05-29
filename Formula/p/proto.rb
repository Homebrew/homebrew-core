class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "ddf62ef965f3a12cc6b0e3e3d0c816ccfb7ce9357753c64726cdf20bb37f8b94"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bb9c2e8cc633f957ebf133c2d471f86c822c0163dac4af4fb6bca377e6a3fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e598faee1eaf2e3bb326f0ed363f1e17263796edd73440e6b0ce6d09fb40a7e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15654a753ad214e22e2d7c1c7513f5cfd481d04e5841f714b0a2c07efb278959"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d3b58ab26d510d80c5541ef6dcb53040a795bf167b9f1c279dd819dea9598b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa2dfad38dc8622025770a9f1ffcd2457e9de0f986c27184c552e7e69c22b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b421541781634dc30d9d486a9d8f281b66606dee3ae94bfb9cb980d9a0238ae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
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
    node_version = "24.15.0"
    system bin/"proto", "install", "node", node_version
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match node_version, shell_output("#{node} --version")

    (testpath/"test.js").write <<~JS
      console.log('hello');
    JS
    assert_equal "hello", shell_output("#{node} #{testpath}/test.js").chomp
  end
end
