class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.13.0.tar.gz"
  sha256 "5a922ad89c7b9b3e1854507c342f36d8c8ba7a488a09114550fe06320208e5f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a4a29792fcbe3b0ac6d3aac6831be90e639a3a9499a1cc377db09171f9e0938" => :catalina
    sha256 "7e0479cb26857bff794200bc6fee56982c483af3a164d4605cf7cd9a53c67f5e" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
