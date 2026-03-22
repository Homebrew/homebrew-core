class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.5.1.tar.gz"
  sha256 "f3b800e9f6ca60bdef3709440f393348f7c18a29f30814288a7326285c80aab9"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e4e70597b1f5e45ce815ad0612fd3a93e046502a1e1e38116b7632a54bcf50d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e4e70597b1f5e45ce815ad0612fd3a93e046502a1e1e38116b7632a54bcf50d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e4e70597b1f5e45ce815ad0612fd3a93e046502a1e1e38116b7632a54bcf50d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5af17e2918b7cb2eebdd8f7965115716a837fc398182d4bd9dc123ff1bd0cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6aa077cbc9cbdefc7e8bc774b9d1b9322b4dac24f035da678f3bd42a84690ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db8cf0a58bbad28267d15f4d8219de4098115afd38180586e4491d555c72eea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end
