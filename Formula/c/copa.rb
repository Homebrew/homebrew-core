class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d12b97f39147c52ae49ef56c439cf2519d11a0de4cbf1af636c156d746149233"
  license "MIT"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1e3d30b97181b93dcb12d038081dc30c3ac12954283cc040d6be0a56d1596e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd09f0a31b320a5669e97054e2db7b134e205a017886d7e93213f2103c5a799a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5da779727c2f3ceaebbc5801110d2122814ee8380d9973021bff10a9fcc0dd6"
    sha256 cellar: :any_skip_relocation, ventura:        "e118acad73b72b5b248a271cf38a44f2a37d2315f9c848db4e3f7e74da5a3eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "357abb73928c6a045f8aeab4f919578b03758ca3d8f51b62c1cadb3f9848eff2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2589ff135ff1b7ff01789178dbbee15dbf454eff4fa23844405b4e16611c0c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3805fe9a2278cdd553202cf86a23111576933ef6df3f8ccaa7c155f680e297a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Project Copacetic: container patching tool", shell_output("#{bin}/copa help")
    (testpath/"report.json").write <<~EOS
      {
        "SchemaVersion": 2,
        "ArtifactName": "nginx:1.21.6",
        "ArtifactType": "container_image"
      }
    EOS
    output = shell_output("#{bin}/copa patch --image=mcr.microsoft.com/oss/nginx/nginx:1.21.6  \
                          --report=report.json 2>&1", 1)
    assert_match "Error: no scanning results for os-pkgs found", output
  end
end
