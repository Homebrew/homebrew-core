class Connect < Formula
  desc "Provides SOCKS and HTTPS proxy support to SSH"
  homepage "https://github.com/gotoh/ssh-connect"
  url "https://github.com/gotoh/ssh-connect/archive/refs/tags/1.105.tar.gz"
  sha256 "96c50fefe7ecf015cf64ba6cec9e421ffd3b18fef809f59961ef9229df528f3e"
  license "GPL-2.0-or-later"
  head "https://github.com/gotoh/ssh-connect.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5bd03526673481e20e14cd61063eaa3592fc7731b79e6c656467328eceaf8238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "576b1a89b5a70f0a4dc4545f97662550db8c16d6c4f064cd51ade4dcea550b6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7176837fc0b291396e82f4915fdea4b4255c0181faa541e6fe9f21f0b8fed74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25da554388b8d7ccd2dd52576434f92ab8628120d6ba7389959b5e71e9483b97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e45ad845a768453d0d0dc278dc9fb39f3a7601f33b79d8c1b5d8e404f1dc3377"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33e6c06bbe902eea4790679f99c9aef340cce1e647238a13c151300afa46ee1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f8bbad21f93b510add271f6f1075807264dfcd93abcfd5da7e3faa9d32338a8"
    sha256 cellar: :any_skip_relocation, ventura:        "768f3960aaffa61d2b6ff11169d90eed94e3a189c6d5c69fb6d176b7d97c8d4d"
    sha256 cellar: :any_skip_relocation, monterey:       "087274a2b2cd22db73d094b35dbb04389fabe7ce7b3d5d68a18a877bdbf50ac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "90d0c91146180552a3a023ceba3850804139eb30b146151efe9c6d889ab9c99d"
    sha256 cellar: :any_skip_relocation, catalina:       "a08dfce847d75746d2b31ed3561e961fdcf950b051c5860e6d137ff5e1bcd1c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1346ceb5b2146940e418e2a95a04d071eda3b97ec0f287231d05856f59639d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ef58829a226ee7573f34e1b8a6282a7f26dfb8d730700eeff992f65a8f84ac"
  end

  def install
    system "make"
    bin.install "connect"
  end

  test do
    system bin/"connect"
  end
end
