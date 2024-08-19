class Oslo < Formula
  desc "CLI tool for the OpenSLO spec"
  homepage "https://openslo.com/"
  url "https://github.com/OpenSLO/oslo/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "d76baf57820b896a648b720e387bb6f8c6137bc05f888a3b1e0e2029827cd607"
  license "Apache-2.0"
  head "https://github.com/openslo/oslo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8aa369ef73a62437f2aa4bd37d40e508c15a77faf74be64b254052c09f7136d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "588243b56e54179dbabc31b5441cd280fd48e8c0d4c6e810728e432f21f1cdfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "081177cd01addb83aa55c63a939fc19a14a957ee288271553fd0f044c551ee66"
    sha256 cellar: :any_skip_relocation, sonoma:         "a73ea7107111dc167676f2bc7e9ab87d6fde983a81240c158d77cac3bb74a5e7"
    sha256 cellar: :any_skip_relocation, ventura:        "6d05071e13f3980b317c5ff34678006735d85b0dd6e1254b8685586f9d112eb5"
    sha256 cellar: :any_skip_relocation, monterey:       "60bc14460a1534923cd36f62ec3a4b48e2f65decddb0cacb2c8ee8789bba433d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb22c17240703d9b7348e2e5711b6949751a9a6b629e22b39101d19bc14e369c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/oslo"

    generate_completions_from_executable(bin/"oslo", "completion")

    pkgshare.install "examples"
  end

  test do
    test_file = pkgshare/"examples/definitions/slo.yaml"
    assert_match "Valid!", shell_output("#{bin}/oslo validate -f #{test_file}")

    output = shell_output("#{bin}/oslo convert -f #{test_file} -o nobl9 2>&1", 1)
    assert_match "the convert command is only supported for apiVersion 'openslo/v1'", output
  end
end
