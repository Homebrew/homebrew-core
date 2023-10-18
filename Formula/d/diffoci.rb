class Diffoci < Formula
  desc "Diff for Docker and OCI container images"
  homepage "https://github.com/reproducible-containers/diffoci"
  url "https://github.com/reproducible-containers/diffoci/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "dc79701b1d823024f3ec529d51a968ba222647acca820c9fb5882c7d7a632482"
  license "Apache-2.0"
  head "https://github.com/reproducible-containers/diffoci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83c2b4c4195ca86bca9124d07eefdf5aa7ccd789df2edd4d88d4ebe5272d9b17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4801af316509f1918865ff84e051d1c619828e4b89a01aac9efe4d82e65fdcc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d88ca24fbd96266fa287c6b1542e68d153efe102ae293d9fd0e4277690e02a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0957737cca6cb0b15963d1a6098ad4175002b4e6ce14120e68d8d6707d99c386"
    sha256 cellar: :any_skip_relocation, ventura:        "c0e98e869f3258fa1a71f5707044dc4aefb840ad0f73131c5345240709e62737"
    sha256 cellar: :any_skip_relocation, monterey:       "6f8a2418f17d10f3bade187a51c17edc3a31d2e9bf9b0501b902f7027a9bcaf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40ae8c80e536818626f35fbf22569ec760010d159877262337076229ab02002a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/reproducible-containers/diffoci/cmd/diffoci/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/diffoci"

    generate_completions_from_executable(bin/"diffoci", "completion")
  end

  test do
    assert_match "Backend: local", shell_output("#{bin}/diffoci info")

    assert_match version.to_s, shell_output("#{bin}/diffoci --version")
  end
end
