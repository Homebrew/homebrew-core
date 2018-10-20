class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/2.0.2.tar.gz"
  sha256 "dea2ea567cfa67196664629ceda5bc775040b472c25e96944c19c74892d69539"

  bottle do
    sha256 "a36461b526e0a974d0f0245b2a197e35413db272db06b819b2e5b7bbbce0200c" => :mojave
    sha256 "3164b78efb9862ea0171b1d88e43fe96d6f01119de756b7a661191f918047b76" => :high_sierra
    sha256 "50af031ee7ce0ae0eefd79801c30530b7fb7cdf65adf56f6c015e6fce6a2b01b" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man.install Dir["docs/man/*"]
    bash_completion.install "cmdshelf-completion.bash"
  end

  test do
    system "#{bin}/cmdshelf", "remote", "add", "test", "git@github.com:toshi0383/scripts.git"
    list_output = shell_output("#{bin}/cmdshelf remote list").chomp
    assert_equal "test:git@github.com:toshi0383/scripts.git", list_output
  end
end
