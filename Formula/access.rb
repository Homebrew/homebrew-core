class Access < Formula
  desc "Easiest way to request and grant access without leaving your terminal"
  homepage "https://indent.com"
  url "https://github.com/indentapis/access/archive/v0.10.13.tar.gz",
      tag:      "v0.10.12",
      revision: "d7ef2a34f7041ff63732a986c7fe3a5940d85edc"
  license "Apache-2.0"
  head "https://github.com/indentapis/access.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "776dbaed1a9d9dff0f6dd41dfd9d2b323a8f26818e13f3bc1671d9df40a3f968"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "776dbaed1a9d9dff0f6dd41dfd9d2b323a8f26818e13f3bc1671d9df40a3f968"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "776dbaed1a9d9dff0f6dd41dfd9d2b323a8f26818e13f3bc1671d9df40a3f968"
    sha256 cellar: :any_skip_relocation, ventura:        "897fb2971104a9f21263aceb17354f7a09a328951ea1ed4b10515d90b2bd38b0"
    sha256 cellar: :any_skip_relocation, monterey:       "897fb2971104a9f21263aceb17354f7a09a328951ea1ed4b10515d90b2bd38b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "897fb2971104a9f21263aceb17354f7a09a328951ea1ed4b10515d90b2bd38b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "495eafedc39465fa48d032ead4a8bc9167322ce36f93c54a12309dd103089b8c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.GitVersion=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/access"

    # Install shell completions
    generate_completions_from_executable(bin/"access", "completion")
  end

  test do
    test_file = testpath/"access.yaml"
    touch test_file
    system bin/"access", "config", "set", "space", "some-space"
    assert_equal "space: some-space", test_file.read.strip
  end
end
