class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "6919232eafbd0c4bbc9664d7f434b6a8d82133aa09f1400341ef6985ceff208a"
  license "Apache-2.0"
  head "https://github.com/OJ/gobuster.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b342220612d825ea80bd1c5569a291868e309ea1b29a9c074a98b6e8ccb6ea19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b342220612d825ea80bd1c5569a291868e309ea1b29a9c074a98b6e8ccb6ea19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b342220612d825ea80bd1c5569a291868e309ea1b29a9c074a98b6e8ccb6ea19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b342220612d825ea80bd1c5569a291868e309ea1b29a9c074a98b6e8ccb6ea19"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5ff54ece6cb45fe81471c6ef9e60ecbd5bdaaded4a76ccb5a47ce7214e4afb9"
    sha256 cellar: :any_skip_relocation, ventura:       "b5ff54ece6cb45fe81471c6ef9e60ecbd5bdaaded4a76ccb5a47ce7214e4afb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb8b43b9b3bb9f2da7b8bef4818b16e23121586a8d8daad8dc057e3921c335f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7fce23ca43b8a3cad902ca7ee55062492b3412ce79175da1dbd04187a20483"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output

    assert_match version.major_minor.to_s, shell_output("#{bin}/gobuster --version")
  end
end
