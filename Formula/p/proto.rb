class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.49.4.tar.gz"
  sha256 "0fa651d739ec8da3a81498f8a9779bfd030cac402bc117889a61a5f2e79697b2"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f0de99992953456d60e86bd05f39d6d883f63403043a8cdfcce35cc93faa20a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd32cec02d854a765d081d3cafdcb75fc5c407c8634651f35f064d034c373c08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fde95da079a08c4dfbcfaf4fc896bf59cd96767ccba415b0ccde8be63140045b"
    sha256 cellar: :any_skip_relocation, sonoma:        "88823e671d03114044a92dc797749c32885bf77a21908fbd76c319444be9e91f"
    sha256 cellar: :any_skip_relocation, ventura:       "e2954f524f2fdeb6f9554659f6840b57d085f4a45932fdb8e2a3b02040fa892d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf1c20a663d30ca64a9f2501a90c8ab09737c07f5368c60c42251717fc16f02b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "011c7615186227a4afaf77e524e9deb94280426389003aa7ed15c0c7a603d8c1"
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
