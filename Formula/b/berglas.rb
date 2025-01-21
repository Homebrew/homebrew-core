class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "08460ae3b50b61c97e77377b46f1815154f6d5ad5d0300bd3ec2efd545310e0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87bbcd1e2ae89f5fd3cfd7f44627e84bc530777a42d874b715c40adb43f22db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87bbcd1e2ae89f5fd3cfd7f44627e84bc530777a42d874b715c40adb43f22db8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87bbcd1e2ae89f5fd3cfd7f44627e84bc530777a42d874b715c40adb43f22db8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe0179ad31b2e73b28eae4fda8f31861a4503159410ad928ac5e31b568dbc96"
    sha256 cellar: :any_skip_relocation, ventura:       "7fe0179ad31b2e73b28eae4fda8f31861a4503159410ad928ac5e31b568dbc96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "107d44fafc6f9fdd29ae907139da5f4455ac4f13dee3e1c269a25f1beadd49cd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.name=berglas
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
