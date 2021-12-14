class BrigadeCli < Formula
  desc "Brigade command-line interface"
  homepage "https://brigade.sh"
  url "https://github.com/brigadecore/brigade.git",
      tag:      "v2.1.0",
      revision: "92a824cff34255774e246be64693230db555efe1"
  license "Apache-2.0"
  head "https://github.com/brigadecore/brigade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b660fdf38cc7f4bbfbc22ba984d0454f24432cd522fa69429a9276f9b79358b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d17aed124f942908c783b452be53695686ccac4726c98246d636ac6c15d6ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "629254eb72dc9d26920764c0ecae18b0e886d0fd3ecae14397dafa8a64341d35"
    sha256 cellar: :any_skip_relocation, big_sur:        "e11a762c74d699b15f049531fed4efa5aed37d9454cb9e1b5270265621ee0c40"
    sha256 cellar: :any_skip_relocation, catalina:       "8518449ea48e287f3dd78f9bc05040d6788a0dae95ab040ebeaa381c53bd7e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d391b56315d9c295337cde29098a1dc6f74bef6d5eb70195d117d86a708643b"
  end

  depends_on "go" => :build

  def install
    ENV["SKIP_DOCKER"] = "true"
    ENV["VERSION"] = "v#{version}"

    system "make", "hack-build-cli"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip
    bin.install "bin/brig-#{os}-#{arch}" => "brig"
  end

  test do
    system bin/"brig", "init", "--id", "foo"
    assert_predicate testpath/".brigade", :directory?

    version_output = shell_output(bin/"brig version 2>&1")
    assert_match "Brigade client:", version_output

    return unless build.stable?

    commit = stable.specs[:revision][0..6]
    assert_match "Brigade client: version v#{version} -- commit #{commit}", version_output
  end
end
