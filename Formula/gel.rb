class Gel < Formula
  desc "Modern gem manager"
  homepage "https://gel.dev"
  url "https://github.com/gel-rb/gel/archive/v0.2.0.tar.gz"
  sha256 "7d69f745986c9c33272f080496aea53719d69d4f465993c740f432ef5f0a3bd3"

  bottle :unneeded

  def install
    prefix.install "bin", "exe", "lib"
    share.install "man"
  end

  test do
    (testpath/"Gemfile").write <<~EOS
      source "https://rubygems.org"
      gem "gel"
    EOS
    system "#{bin}/gel", "install"
  end
end
