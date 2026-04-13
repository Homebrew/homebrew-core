class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "d2257c94f4134556a8219e6a8f92d39b5320a970ebde0272f0df43c92449ce73"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31de97d1e6757af0901510564b04c91997bb910a794fc28a9c45d9922b6124f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31de97d1e6757af0901510564b04c91997bb910a794fc28a9c45d9922b6124f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31de97d1e6757af0901510564b04c91997bb910a794fc28a9c45d9922b6124f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "33845a2849503c6f19fca7add1a3b6a2ca0ea7df83b8670f585659a6890bec98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad4a7386afef03242dfa2ff49eabf4f4928f48c1b2aa3380e50fd2679a4d1213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "672afdb40aad5e6c235576b5953eeaadd74e576cac2d9d091f82d1a24c4ca15a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
