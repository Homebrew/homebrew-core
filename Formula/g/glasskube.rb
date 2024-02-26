class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "7b9b1211a0ce6ad0b995836b8e3527b8c13de38e1a1f37ad9fb7697707a8c1e4"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b4de34d2d7d888b19dc92aec90d2939292ebd3e73543ae1cd6000fa74a5b4c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44072ea39b6b95934e599b310c18d6bfec59495b972e98857674c285a2175af5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ee46f983c01584305de152dd114df1ea860e75f1abfb4c9b6e209121ce8d8e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "86bec5397943381aaf0a863797a33fdf17905e75b86b3fbd68acc92af55b55f3"
    sha256 cellar: :any_skip_relocation, ventura:        "729c7983d8661d341546e5e80802557d36efac4656f2705b940c314b51143c64"
    sha256 cellar: :any_skip_relocation, monterey:       "619488ec9778ee5d33656463b5f81e6e355579e0a0214888059a1aa5d3313b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4447e345d432b0407173e5005f51506d177e7efdd24becb3ed9de142475c512"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
