class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.6.2.tar.gz"
  sha256 "e94be0967864593b44870cb39c2473fccc91d42d37fa500006646385ce2e4194"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c29d0ea05cea25976c9bfb21536c2e165823040cdf421d3ecfa11d0ec80c4050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c071f623204c5bd928c6e9be5c7ba5f497772933cd8095a90a6999e8b784bcff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "361db60fa54b675027ae897e7241a53de8ea6bbe1004208bbb200566145fe517"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46dbd4edef1ccc93cbc06d6a445e56537cf6d2f0e8ac43f94cecb628631ef2b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8aa641bfce352397e34ac22f79e8d240b43754afde95f289e71da89313d8feed"
    sha256 cellar: :any_skip_relocation, ventura:        "1ee75dddf7f642b682673587bfdce1901a26875bbacdf25eeb2e5096ab160128"
    sha256 cellar: :any_skip_relocation, monterey:       "9e96ece41d1cab6ae94a5578c415c926ca9e3cbe90d7f517237de3ae5b790735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "362096d572cb379f45481efd03f7f387ceb4f7216315ded8605e47b6452a8290"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_predicate testpath/"helloworld.tar.gz", :exist?
  end
end
