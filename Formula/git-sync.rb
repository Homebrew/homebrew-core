class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.8.tar.gz"
  sha256 "d1ce28b7480940c3e729aeb9b7c5b925a77add3322c9ecdb0edd9aab4f515795"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6da7fd738ce2d7d3610a8f7f31e49a6e4a9ebfc80500eab5fe86da9340acae88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6da7fd738ce2d7d3610a8f7f31e49a6e4a9ebfc80500eab5fe86da9340acae88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6da7fd738ce2d7d3610a8f7f31e49a6e4a9ebfc80500eab5fe86da9340acae88"
    sha256 cellar: :any_skip_relocation, ventura:        "a5274c550ff13c16fa31eb0e5885df1e806ae7109e71ec9c8254c947bafc668c"
    sha256 cellar: :any_skip_relocation, monterey:       "a5274c550ff13c16fa31eb0e5885df1e806ae7109e71ec9c8254c947bafc668c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5274c550ff13c16fa31eb0e5885df1e806ae7109e71ec9c8254c947bafc668c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f65ed1b2828182955092576a11361215d37f66aaaf5f8502ac25c3793b0af3"
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
