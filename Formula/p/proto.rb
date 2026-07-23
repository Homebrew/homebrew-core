class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.58.2.tar.gz"
  sha256 "f49877cfb92dcec60240ca12bee8caf6b69f34be171c1bd80c1d6ffc5c86082d"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "026a23a26d4b2a71497716e1f7415fe78ada5453ddf0bbad3bdbcc7e729324e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04458f9af1c20a8709a4225ffa071b771d0ba04e60d9061655bf36e8bb191c99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b59b50c1bef47ccba860211543aa1c8a0c878162769afb1d0a6b94884291dc1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "772bc053a31231b60dc0299c9f16df9103e4051089847ce92c6983956c74326f"
    sha256 cellar: :any,                 arm64_linux:   "71ce3e9c6dd3079f2e3fc86fc49c59d91e97f3d1894639d3d802649b01ef38c4"
    sha256 cellar: :any,                 x86_64_linux:  "fb42ad31264da96a23451e34893dce5fa16dfe734b94ced6915370bc587e8408"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
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
