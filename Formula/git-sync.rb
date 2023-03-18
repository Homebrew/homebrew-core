class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.5.tar.gz"
  sha256 "cd627f00f291ca4745863a6f62ec834a54f3b64980eb0f3f4e8527d3203e815b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06152b684efba4d46fe0981d379d94aa8f126e2ba466712ce6ec4cc1780dfc2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06152b684efba4d46fe0981d379d94aa8f126e2ba466712ce6ec4cc1780dfc2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06152b684efba4d46fe0981d379d94aa8f126e2ba466712ce6ec4cc1780dfc2a"
    sha256 cellar: :any_skip_relocation, ventura:        "51925ce6b0ec567a5c16b02075aaeb1f31219d1ff8cc2dafa24443a9453cb2fc"
    sha256 cellar: :any_skip_relocation, monterey:       "51925ce6b0ec567a5c16b02075aaeb1f31219d1ff8cc2dafa24443a9453cb2fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "51925ce6b0ec567a5c16b02075aaeb1f31219d1ff8cc2dafa24443a9453cb2fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c73e0f9e63a95d27f941ff117c4ed275c1f0880f74debae8b63f4bc453d6dce"
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
