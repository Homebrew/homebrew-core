class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.72.0.tar.gz"
  sha256 "fa49bdcfc35cca74f01166c031bbd7448950ae29aaad6b20b131b37cf27e4b1f"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b44c0a4f45f13abbd049aaa9eacff93703382590d940feb03cf10436d0a0bd90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7223f68287192fe1cdf4b7edd884ad7945cc607ad054c229aa651d35d7d18de9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59bdfdaa50188f807dcdc506146057f2cf379f6a977fef1318161693d5388548"
    sha256 cellar: :any_skip_relocation, ventura:        "c055072a66800755330f7d2cf733b3f8286ec33c40132cabc7277140e570bd14"
    sha256 cellar: :any_skip_relocation, monterey:       "709595c649541ea27a703f0a64cac204d772f46e34507f8522b57b4b5e6c25fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "8abff78757b0307c98fc6696e8c06aeade4065f66332ef1e277768d3c66bd83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ffad512104e0336d4268da8e32ebc2df6e989d125c1b6e84c7d1eeeab2222b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("#{bin}/dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
