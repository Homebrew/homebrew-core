class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.16.4",
      revision: "ef9c472c5ff1d7fe4a0c8f8e1d8c0146f836a894"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b4aef92524baa79de852b70709e6178483204b0c0de8f28e3169a3ba071345e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "625718dee2e92f7641a8a209abec329a716432d7f7ac60edfaeacba1acf43e20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "408251bf9883787e3589c893c2ef8a337699fdb8cccaadca447d8dbf89bf57ca"
    sha256 cellar: :any_skip_relocation, ventura:        "e4e99a3bd2d276bcafcaffe9c9bbac85edeb1adf90ea986794b0d9c6f79a9328"
    sha256 cellar: :any_skip_relocation, monterey:       "47660f8df39e0679ec3534ed24f7c007299dfcae3beac1c4b93ce6a833129a4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4081896448a1f8e6a9e932796792644e7aa4fe8dd194e5d4127b363423c2e9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7a7a6c2c9a9c301046007889e302f19112745321c05525de7378aebfd9d392b"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
    pkgshare.install "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
