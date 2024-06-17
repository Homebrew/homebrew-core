class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "14932a793d37adfe0289655f24c3ffad51cce166bad1d8abede852a86d4b209c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99f775aa1d54ff99991d9bfb00037d4ca4afb3d7341db67da31578aed2b2422e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a72d3dedf6208a12f345edbfde377a6eec50a6c17897a94a4379229a7896fa02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43b5451ccc03e0a65f85b28c71e82c7dc386f4e5d4bac9bcadc8c7a766740fff"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bce761e9d40753537a9728bceddd6095a0a2196040d7e73c34507a0503c7968"
    sha256 cellar: :any_skip_relocation, ventura:        "88f6e6a3c260cdb927094e0086ef289244fef7f1d4ba4d75f72a0a7be6f2d7dc"
    sha256 cellar: :any_skip_relocation, monterey:       "aad8af9a411b984d814ef22ddc8a48240337378ef00c7f6de2270c8c87ec1ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5661b74aa9cce32cf699b9069109631237e6d88ca783116687f92d152f3ce5ad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
