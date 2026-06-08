class Ipapatch < Formula
  desc "CLI tool to patch iOS IPA files and their plugins"
  homepage "https://github.com/asdfzxcvbn/ipapatch"
  url "https://github.com/asdfzxcvbn/ipapatch/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "e7593e9d7cb77cdebce80f76129050cae984a9a41c4bfa12b0b5eec8dafa6f3a"
  license "MIT"
  head "https://github.com/asdfzxcvbn/ipapatch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71020649c2c6e2d9cd414e7ce47dfda3705c391475fd8f754e5ae368f397a2dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71020649c2c6e2d9cd414e7ce47dfda3705c391475fd8f754e5ae368f397a2dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71020649c2c6e2d9cd414e7ce47dfda3705c391475fd8f754e5ae368f397a2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "36116f1a830e434af7dd1359f2d47f44dad44375aefe8622e3ba41ced5005e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d49a6091bb1d3648611e21cb0c0cbff0f7a883af474118a5b869259f4e6d621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5036f83e88528a1c2b33581d624b366cc5d1fb0ec56b260208e52fa62d827f0e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/ipapatch --input #{testpath}/fake.ipa --inplace --noconfirm 2>&1", 1)
    assert_match "not a valid zip file", output
  end
end
