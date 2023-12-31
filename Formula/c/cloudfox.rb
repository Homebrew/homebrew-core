class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "6b72280c71a894edddd09ae05a6667f76ed4e4049b137d9a651ac618d78a55af"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13e9c7a8d56aab58ff6cd119498fed59f1d8d217948d9abb0320d218068385c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98724a93eccdbd25e0871d0c14c834b97b6cc3115150f3318f4913b210530093"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06d007ca0c6de187489d78aa1cbfb0f967e4f612fcec339a70bdd4dd63f5e1a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d57ad769de53d30c4bcce78cc7450468ae8118966031a15d8c29e7c905bd7af0"
    sha256 cellar: :any_skip_relocation, ventura:        "6f4f9806a5051c4e9280709d789992cd7c3a2ffc5c8eb5e0d5f5960ad477b909"
    sha256 cellar: :any_skip_relocation, monterey:       "dc6cbdf5ca30d645dba543be70018ae078c065205d8e85ccd94cf02530cb1abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30dfc4a2a0c2221e85870d7b7388cc84ac16b8ee45c26fc3c9b4c9c1816d562"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
