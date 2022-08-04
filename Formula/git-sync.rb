class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "0b65c3f414c98b13d66e99c86680c67348be50d578f88a0888720888b3fcd700"
  license "Apache-2.0"

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
