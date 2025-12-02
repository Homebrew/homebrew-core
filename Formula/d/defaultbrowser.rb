class Defaultbrowser < Formula
  desc "Command-line tool for getting & setting the default browser"
  homepage "https://github.com/kerma/defaultbrowser"
  url "https://github.com/kerma/defaultbrowser/archive/refs/tags/1.1.tar.gz"
  sha256 "56249f05da912bbe828153d775dc4f497f5a8b453210c2788d6a439418ac2ea3"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "543a41c1fafa5da62bd86dd329b951a9a7d23b5aa2187b805f454c813308ddbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d7921f729c6afa9a924ffc175918d74e9767059e645491af9cae1df09fa80bfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "babed0d9771439d08249d6ca58d8c468a2f646074a44ba3f8f1b90505054ad7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75b63c5b51b3304105737dbbc18f4acca44aa2355dc06a06160220e5c07f42ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdbee46ea9cdc0bf6adbea67eed257663c77d745af838f4a2e71f69987242d6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19e88d5316731019db1bafd3361af53fe3a4dd40348ac5a30bf34754b250f992"
    sha256 cellar: :any_skip_relocation, sonoma:         "3820ffb79652325db2076af61b4d5c879b3dd1acd20c56a88160c164f0cfe63b"
    sha256 cellar: :any_skip_relocation, ventura:        "6312f36faa5128d899e9410d89ecbf6425fc2e5aff3ce30398092f6c13ad8768"
    sha256 cellar: :any_skip_relocation, monterey:       "cb836a15dc466342c11bb7cdf35370b261b77723d81438664f89e84513a06f8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e796471951ee1290e11172aea1fff0b59c70cdbbfef43303bf11a3178e676a7f"
    sha256 cellar: :any_skip_relocation, catalina:       "e03bfa37fde424b0d7e76e6d2f99a26bad458e9d2bdf912db06d83d64bfe5a17"
  end

  depends_on :macos

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # defaultbrowser outputs a list of browsers by default;
    # safari is pretty much guaranteed to be in that list
    assert_match "safari", shell_output(bin/"defaultbrowser")
  end
end
