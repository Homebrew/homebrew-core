class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.25.4.tar.gz"
  sha256 "12ac67b40a89dc5a9969579209b4095605d9f39f755002a14177c768720d284d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b9293555370cf00896152fff97e28c4a9743c7170161813682bcd60c21bf0ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2d45819eaf2984e188b18b82f0eaed4b7ed6e9cafc37a99804993c627aac547"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "408160a4cc41126d87fd34070ab7c4188214d7b6babea679f4d61115033dd58a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f6d81b91f31a03106aa9c8eacb4a371ad49cdba64010e96ab751c75a6c91750"
    sha256 cellar: :any_skip_relocation, ventura:        "cd0de317a49f6bb967793d4ff50e70f8a48c89e217be8d772ba96e8c027392f9"
    sha256 cellar: :any_skip_relocation, monterey:       "e74f2fa08154608f73796891be46e2cda198b5fc32d258726a6b3ebe5c4c1320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c45720cdb8325445bf0563d3172791772ca8e9427028b0d169797c42ba5376d0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
