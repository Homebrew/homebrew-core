class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "2b881d2709dae40532da12522f46ae698f206b3504542651a07c155db3bc21a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8e13dcf9637af82ad3aa05b6df16fe04ffb41a69055567be056cf16f170ebdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b549d415782c77a8f10081cdc1956d5f746d10315ea6eab14a5bae1e252f998"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5913f4f0c1a4d65f3a72853dfbb512c05d5193283de86ad7992f8e90dc08192"
    sha256 cellar: :any_skip_relocation, ventura:        "28c4e90976266974a9e48d771503c1ff51a3a445d7b66403b93b6f594f43916a"
    sha256 cellar: :any_skip_relocation, monterey:       "2b0cdbdd1bac0dd770e5dd2021f06f617443b70563bcc55f390659e3d605cfd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "46e36d29a32cd7b8cd72bc550086af4cc47d7c44f8a287bdf048c6d42a5abd64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "417dd478feb45e49cf511f8327ffb520ae6c7211b2bd60df1696150c94f024ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    assert_match "connect: connection refused",
      shell_output("#{bin}/popeye --save --out html --output-file report.html", 1)
  end
end
