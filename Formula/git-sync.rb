class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.6.tar.gz"
  sha256 "59a56f80cdd05c883ba3c6148d960b67a26d1ae6939eca99bc86f3ee612e6458"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1694c242777669a5f69232b1b680341b4b506c747d6ab0eb19dbe94e6a736b45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1694c242777669a5f69232b1b680341b4b506c747d6ab0eb19dbe94e6a736b45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1694c242777669a5f69232b1b680341b4b506c747d6ab0eb19dbe94e6a736b45"
    sha256 cellar: :any_skip_relocation, ventura:        "dff5cb5ece2a5bfb94ba74d8e4f59ee6e9d68170ae2c6d1c8c4297c9d67ecbd8"
    sha256 cellar: :any_skip_relocation, monterey:       "dff5cb5ece2a5bfb94ba74d8e4f59ee6e9d68170ae2c6d1c8c4297c9d67ecbd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "dff5cb5ece2a5bfb94ba74d8e4f59ee6e9d68170ae2c6d1c8c4297c9d67ecbd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8c54fc591f710c6f7ad64ed5cb6614401754bc970aa9b98d46caef557b24a6a"
  end

  head do
    url "https://github.com/kubernetes/git-sync.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    inreplace "cmd/#{name}/main.go", "\"mv\", \"-T\"", "\"#{Formula["coreutils"].opt_bin}/gmv\", \"-T\"" if OS.mac?
    modpath = Utils.safe_popen_read("go", "list", "-m").chomp
    ldflags = "-X #{modpath}/pkg/version.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/#{name}"
    # man page generation is only supported in v4.x (HEAD) at this time (2022-07-30)
    if build.head?
      pandoc_opts = "-V title=#{name} -V section=1"
      system "#{bin}/#{name} --man | #{Formula["pandoc"].bin}/pandoc #{pandoc_opts} -s -t man - -o #{name}.1"
      man1.install "#{name}.1"
    end
    cd "docs" do
      doc.install Dir["*"]
    end
  end

  test do
    expected_output = "fatal: repository '127.0.0.1/x' does not exist"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)
  end
end
