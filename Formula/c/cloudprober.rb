class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "273b4046f3d0c83879cd36af651e07ce3ea65c84edba215f76788adeaf35ad3a"
  license "Apache-2.0"
  head "https://github.com/cloudprober/cloudprober.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5e186d2b53a8186f0dc6a15cb4b778b2f7b89016fa061d7aa7bccebf84afc1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b25397a6b90e68b277ab8b630d9f26fd817500c8fb581da6ee5e8780aad843d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1316599890cee7e1dac639c78d3d06eb0db7062bba46b07c01b1f0b203885361"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35a877e14eac6e8f94d5970beefc091025951c74f19252c617e177b3d3f97018"
    sha256 cellar: :any_skip_relocation, sonoma:        "0350fc4bd2488211cc0df6e1dab417af67f93994d772ea9338ff3358bdfd884c"
    sha256 cellar: :any_skip_relocation, ventura:       "cf8f6c807ffe18af74f85c4563e1cf4c49b59cc772a8c95622f8be886269d0e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35d464a5fedb85512d339040eb43710422b50d8d8d32cca686ea38d621d4ed62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6441c40f98cf187f97e9b9ad75b00252173f5ab7cde05a6651b218e34c7944f9"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
