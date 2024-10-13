class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "1975bf0a0aeb03e69c42ac626c16cd404610226cc5f50fab96d611d9eb6a6d29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6249e8404da965e941fd171832b722cc052ae5431475dc02afabd2b85a61c54b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fda3f73dff9a59dff79bdc79351361a6f737e298c02bef4b585f0991e80e793c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e78222b47bc21a5c77b73dbe032ad775d8a22d6e468029c5c3e10e23b89f39ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cfb8c02d7e116cee63aa1e520d774ea7ca40869eabce292a529058c40072ba4"
    sha256 cellar: :any_skip_relocation, sonoma:         "52cd6b8254a177de282c0c484dcb04219151f2f90c934d0f2a9916e65d006070"
    sha256 cellar: :any_skip_relocation, ventura:        "ff33031c27f3b7a78d9a82b065b9c9659f5c9cb5a5362e216a9ad30628287631"
    sha256 cellar: :any_skip_relocation, monterey:       "f17c5dbafa0861d76ccb6a19f8619c4e241bf62ec204595f6578eb690de3078b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df523bc15f0a2c1d79906b32e4d2ca64896969770f5c235cde3b46e91e5736e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/pulumi/kubespy/version.Version=#{version}")

    generate_completions_from_executable(bin/"kubespy", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubespy version")

    assert_match "invalid configuration: no configuration has been provided",
                 shell_output("#{bin}/kubespy status v1 Pod nginx 2>&1", 1)
  end
end
