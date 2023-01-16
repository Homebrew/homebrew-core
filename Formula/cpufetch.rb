class Cpufetch < Formula
  desc "CPU architecture fetching tool"
  homepage "https://github.com/Dr-Noob/cpufetch"
  license "GPL-2.0-only"
  head "https://github.com/Dr-Noob/cpufetch.git", branch: "master"

  stable do
    url "https://github.com/Dr-Noob/cpufetch/archive/v1.03.tar.gz"
    sha256 "550168e0523240a1fb837e85073e0aa69de1894f1b89ec3a5721a5d935679afb"

    # Upstream issue ref: https://github.com/Dr-Noob/cpufetch/issues/168
    # Remove in next release
    patch do
      url "https://github.com/Dr-Noob/cpufetch/commit/22a80d817d57814fc552365ad553c0a22f065fcd.patch?full_index=1"
      sha256 "063b602cd5013ba7c2c5ea4e134c911164ec49b2ed14209c313c2ef005bd3d42"
    end

    # Upstream issue ref: https://github.com/Dr-Noob/cpufetch/issues/168
    # Remove in next release
    patch do
      url "https://github.com/Dr-Noob/cpufetch/commit/095bbfb784f0b367558741e9b02f6278126e1c93.patch?full_index=1"
      sha256 "494756db04ab00a0a57d519704f5032d2b77e7539d4c0233b789c5a6178fbab8"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5149d2074889219c812f6ca2505e83347ca1534eb9f0892d998a18da03bd404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff63b2b85c84be38b371a3e37367aecd8685c85856b2ca586dfe2f147f940980"
    sha256 cellar: :any_skip_relocation, ventura:        "3253382bd879bd53a615b56906b13fb4d9899c915451c385f659e1ce9b431af0"
    sha256 cellar: :any_skip_relocation, monterey:       "e51fd38738c0ad936bfffb88fe4dc57e8e69c4b023fb0cce5d1a5c98f6259553"
    sha256 cellar: :any_skip_relocation, big_sur:        "46c8c3b2ed335093b4e2eee7c969a114b7213ff6d5342b782dd227cbfb54db43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5949883510a59f2b7d8f4dd0c97678d249702a879d97bd0978671a983fb0e7a"
  end

  def install
    system "make"
    bin.install "cpufetch"
    man1.install "cpufetch.1"
  end

  test do
    actual = shell_output("#{bin}/cpufetch -d").each_line.first.strip

    expected = if OS.linux?
      "cpufetch v#{version} (Linux #{Hardware::CPU.arch} build)"
    elsif Hardware::CPU.arm?
      "cpufetch v#{version} (macOS ARM build)"
    else
      "cpufetch is computing APIC IDs, please wait..."
    end

    assert_equal expected, actual
  end
end
