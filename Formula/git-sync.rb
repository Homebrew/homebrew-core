class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.5.tar.gz"
  sha256 "cd627f00f291ca4745863a6f62ec834a54f3b64980eb0f3f4e8527d3203e815b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d58a6b9e5618970b1dd372c9b9e6a0b0e73ca1907c6f2128401cef2b46b6525f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b94df27a1ffcd98ec30d7b468f89b8122859be0b1e4102e11c5f265b9360b891"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88706c64be147318ba9974083b8762231738ec6ae0314bdcf39d7b37b9c567e2"
    sha256 cellar: :any_skip_relocation, ventura:        "a316f105613544b098331b0184ee29b29ffb6fcf83c2402912279fc5a3a8fa40"
    sha256 cellar: :any_skip_relocation, monterey:       "033a0b3a34ff3c0928ffbe27f1cf678e123ad36c5179fe9ecd79fdaecefaadb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "07db0d12d3be5b615ea6971c04aa9daafc0b7e9e60288c0bb47cead0ec7f3731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb5781268308f09a99f2a5e66f754049b7324a919d96050ad51a9c9d34bc81d5"
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
