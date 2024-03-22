class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "a2adaafbed9f6a05b69567b16f0c40d6047ce1e70f9d56c4f78918095e83076b"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab34a1e444d93aa9c7a8b99c5e49c42aaedef66b9f63fb38eca44b751e3fe929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7126dda3d069e6c4476e7744cd6876ceb068ba52d1d2e8ff287e04c72d8f1da3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d33280b6238df2b7eadcde9918dc3cf3aa5696b9880ddd801af570716d299b20"
    sha256 cellar: :any_skip_relocation, sonoma:         "3273dbaad27453a41ea2c0789a16f2f12bf6f894f057ccb5694b43898cb524db"
    sha256 cellar: :any_skip_relocation, ventura:        "1c3a7d4b63ff333e93ddc24d1b30652ad3b30c03c4281b05ef43435a165693e0"
    sha256 cellar: :any_skip_relocation, monterey:       "ef81b45bcb135ff776eab6245ff3d844e44f64fc536ca8f34bac8e4b5d1512f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34c4602a525f9f2d7d953dc8a37ce933f45ba932bc915ab256f3ae6e0a2c575b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/project-copacetic/copacetic/pkg/version.GitVersion=#{version}
      -X github.com/project-copacetic/copacetic/pkg/version.GitCommit=#{tap.user}
      -X github.com/project-copacetic/copacetic/pkg/version.BuildDate=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
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

    assert_match version.to_s, shell_output("#{bin}/copa --version")
  end
end
