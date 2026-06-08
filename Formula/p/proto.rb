class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.57.4.tar.gz"
  sha256 "bdd6813590fd45324032afb0396070aa6fca9158a1f080ebe1f74439cd2ef490"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6adf54781038a727e4af7e1534cde7ae7883f6ca8daa8a7328dc5cd6fd80d1df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce8386a83909eb2976bc35d79167e426303c78d372c5061060de10088270a2e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "194bf10d1aef569f49912bbdf1ef7153a377d50cd2a163ec934f9bffb3012b7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "861aa54e3a80097c46646900c8185ba585784e09e6321eaece97e45855177f18"
    sha256 cellar: :any,                 arm64_linux:   "c050637ab6e00320f9c6b49d69e1df3601b82ba67b23c1e78a038190aa9e1ea7"
    sha256 cellar: :any,                 x86_64_linux:  "534935a83b4878a4150ba90f96be9c77ad424064aa2aff1360b594f7bde9bad1"
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
