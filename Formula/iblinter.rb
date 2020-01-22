class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://github.com/IBDecodable/IBLinter.git",
      :tag      => "0.4.20",
      :revision => "4b518dafbd64a329374f285c5f27bc6c08be7a38"
  head "https://github.com/IBDecodable/IBLinter.git"
  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/iblinter", "help"
  end
end
