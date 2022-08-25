class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "f0ed5255d409d3cd7a56686831532669ac8034e2e9212c91e993c2aa81a33fe0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fb05fc3525baf5fb04707d22f5d5a9a1c55b6fedcf1b3028a47ed8d53fcf500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fb05fc3525baf5fb04707d22f5d5a9a1c55b6fedcf1b3028a47ed8d53fcf500"
    sha256 cellar: :any_skip_relocation, monterey:       "aab78cf307f005c1ae828bcedf8eea5865c0841b5be1e007dd17416057fc1e27"
    sha256 cellar: :any_skip_relocation, big_sur:        "aab78cf307f005c1ae828bcedf8eea5865c0841b5be1e007dd17416057fc1e27"
    sha256 cellar: :any_skip_relocation, catalina:       "aab78cf307f005c1ae828bcedf8eea5865c0841b5be1e007dd17416057fc1e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35078cce86078db4dff5cbe59b5b5cda7cba80fbabf4b9f0854c7b148b0ca5e4"
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
