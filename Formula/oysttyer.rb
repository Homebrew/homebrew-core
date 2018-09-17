class Oysttyer < Formula
  desc "Command-line Twitter client"
  homepage "https://github.com/oysttyer/oysttyer"
  url "https://github.com/oysttyer/oysttyer/archive/2.9.1.tar.gz"
  sha256 "2539e993f72bc4c4547dc8c93ae385d06f285a136bc3e9192f4ce0182f6619e3"
  head "https://github.com/oysttyer/oysttyer.git"

  bottle :unneeded

  def install
    bin.install "oysttyer.pl" => "oysttyer"
  end

  test do
    IO.popen("#{bin}/oysttyer", "r+") do |pipe|
      assert_equal "-- using SSL for default URLs.", pipe.gets.chomp
      pipe.puts "^C"
      pipe.close_write
    end
  end
end
