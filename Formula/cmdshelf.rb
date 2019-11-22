class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/2.0.2.tar.gz"
  sha256 "dea2ea567cfa67196664629ceda5bc775040b472c25e96944c19c74892d69539"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "e4093bda9528ae027e122f321e2f1a44d3b4fc8b569e2bf0eba526399cccdacd" => :catalina
    sha256 "4c83af8661b368f727a389f12d434be45655d10aef9ae1acb8b2be830aae0558" => :mojave
    sha256 "c0cdc78df3f3896e4e8ba2112ec6e5189682da06419637ebfa9d660ff4fb902f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    man.install Dir["docs/man/*"]
    bash_completion.install "cmdshelf-completion.bash"
  end

  test do
    system "#{bin}/cmdshelf", "remote", "add", "test", "git@github.com:toshi0383/scripts.git"
    list_output = shell_output("#{bin}/cmdshelf remote list").chomp
    assert_equal "test:git@github.com:toshi0383/scripts.git", list_output
  end
end
