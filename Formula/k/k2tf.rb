class K2tf < Formula
  desc "Kubernetes YAML to Terraform HCL converter"
  homepage "https://github.com/sl1pm4t/k2tf"
  url "https://github.com/sl1pm4t/k2tf/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "9efdac448a99dbdda558eb93b63ed0b3ccabbac43c14df21ef3ba9bd402a4003"
  license "MPL-2.0"
  head "https://github.com/sl1pm4t/k2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d502873a00e376dd401a35fef734c406e676f78ce142fa74ddf586bfa7a32185"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2d808b0a5af45f1ef97f4e8da0bfd7d479d255df1e3defb967181ec464507b85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e666bb71c6081a4ee995830eb2461f9acce7dc59effc322caec0009d1798b16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0374e106ff77fb303c7d3a44429f0479b35b15bbc9c8c2548bf9da1189282e8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a42b34afc2e1ab54c527689f0a5ba88a815b99bbd9f5049577d53f57170422"
    sha256 cellar: :any_skip_relocation, sonoma:         "85b15961f36f64d617228cfac86c173c3a5aa80c40e64442481f053e4647876e"
    sha256 cellar: :any_skip_relocation, ventura:        "8a1f65789b5060b8e020770642231486d6b9d563645bc4f2ffe9337dfb2d36f0"
    sha256 cellar: :any_skip_relocation, monterey:       "641bb527c2a11bb9aa649e747b19075098ca04e0575c187b2bf35e0036fc0cae"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "21ada95d25defedff835157ba130ff2c7ada2bfeef49da4aaf56facb5c11bad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e36e46f8c6a0361f338cd665cb5b2899a95cd70acf46d2280367b206b24096d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    pkgshare.install "test-fixtures"
  end

  test do
    resource "homebrew-test" do
      url "https://raw.githubusercontent.com/sl1pm4t/k2tf/b1ea03a68bd27b34216c080297924c8fa2a2ad36/test-fixtures/service.tf.golden"
      sha256 "c970a1f15d2e318a6254b4505610cf75a2c9887e1a7ba3d24489e9e03ea7fe90"
    end

    cp pkgshare/"test-fixtures/service.yaml", testpath
    testpath.install resource("homebrew-test")
    system bin/"k2tf", "-f", "service.yaml", "-o", testpath/"service.tf"
    assert compare_file(testpath/"service.tf.golden", testpath/"service.tf")

    assert_match version.to_s, shell_output("#{bin}/k2tf --version")
  end
end
