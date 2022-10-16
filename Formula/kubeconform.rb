class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.5.0.tar.gz"
  sha256 "c93d091a4abf3ea5245a281a0b7d977833c361af0840cd6cc5c2a638b98f1f9e"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1c3955cd514a49b752dd0d257f3d9b9ba8e56d264ca8984b020eda2970c6f51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e79e32e43d8058963dc404ae5032a14fdb5116826604a8aa249777b7e5e242a"
    sha256 cellar: :any_skip_relocation, monterey:       "6a266e51b3483b03a7074e6b950ceaabc052a7178cb4c9f482a9f8b70284d688"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1170a54e0555beb4ecce541351c133e6685d5e03abcd2af304abea6bb97cfb2"
    sha256 cellar: :any_skip_relocation, catalina:       "c128eedeeef0e40f02c17c063c108e6138dfee50f41d6469ea8db4af24734c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eccc7d5135322bbbcf79cffad2174ef0ae69585515640c270b2811c626549455"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubeconform"

    (pkgshare/"examples").install Dir["fixtures/*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    system bin/"kubeconform", testpath/"valid.yaml"
    assert_equal 0, $CHILD_STATUS.exitstatus

    assert_match "ReplicationController bob is invalid",
      shell_output("#{bin}/kubeconform #{testpath}/invalid.yaml", 1)
  end
end
