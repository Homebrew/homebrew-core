class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "937f03d238d392bbebcdd65318e5a26213dec6f1e90d5fd2cd9111cdc3311444"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17fb3fb347d77a4b35fc1b804a0355b359543f03f4e81426b4ca6e1a48ba2b95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17fb3fb347d77a4b35fc1b804a0355b359543f03f4e81426b4ca6e1a48ba2b95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17fb3fb347d77a4b35fc1b804a0355b359543f03f4e81426b4ca6e1a48ba2b95"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ec289a440fd4c5057d43bb786049fc203618f6c847450bf378c28a062facf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0ec289a440fd4c5057d43bb786049fc203618f6c847450bf378c28a062facf3"
    sha256 cellar: :any_skip_relocation, catalina:       "f0ec289a440fd4c5057d43bb786049fc203618f6c847450bf378c28a062facf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c28a6f867a36f29124ee452de1f01166dbdbad68dc8633f12427a6248b0b68"
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
