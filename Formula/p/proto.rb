class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.60.2.tar.gz"
  sha256 "f78d203d292224603e831f0f03cc35e612bf48a1de1697ab34fea86ea97bfe21"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efa28969e5156a34d7b84703b0dda1066838d5068ef0aa716c5a488dac27a288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58d32c68f31374755b1e9d29a80b1cb53c564eb66d989294329298899578440d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ed64767c961f7f7b0c92b1f288003eac256bf34ef664379573f4168f7f4e32c"
    sha256 cellar: :any_skip_relocation, sonoma:        "58288b2af9ae9fe815738f1ccb3a5f0845909617e78bf320a9b798e1e6140322"
    sha256 cellar: :any,                 arm64_linux:   "d1abc8b07482e2042a7864a60a974e11a886cd114dda3ce7fc8e12d1e4917c66"
    sha256 cellar: :any,                 x86_64_linux:  "c86e5ec361515beaf5c3d95d6605d6689482b44c070cbcb4312c7c32a706e6f1"
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
