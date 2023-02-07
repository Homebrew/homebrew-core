class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "998626c5ab46e72c29837e42a88afbc6d65ee6ea058fe027ae783ff39bb82b78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "804143d01298df86953e628fbb3cc005bb3a4f48bc0a13faa3a1aee3f00c0784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "804143d01298df86953e628fbb3cc005bb3a4f48bc0a13faa3a1aee3f00c0784"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "804143d01298df86953e628fbb3cc005bb3a4f48bc0a13faa3a1aee3f00c0784"
    sha256 cellar: :any_skip_relocation, ventura:        "17b68939e36ae942c75e6beec232f432ab65841a43e4ab921f74b443b9fe01b5"
    sha256 cellar: :any_skip_relocation, monterey:       "17b68939e36ae942c75e6beec232f432ab65841a43e4ab921f74b443b9fe01b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "17b68939e36ae942c75e6beec232f432ab65841a43e4ab921f74b443b9fe01b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0faa136717ed80c81c3c120bc30489650da157dde30654339dcd81ea06e8d777"
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
