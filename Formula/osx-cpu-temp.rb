class OsxCpuTemp < Formula
  desc "Outputs current CPU temperature for OS X"
  homepage "https://github.com/lavoiesl/osx-cpu-temp"
  head "https://github.com/lavoiesl/osx-cpu-temp.git", :revision => "376883f1d5251e104216dbdb80cb0c7a77a2bf7e"

  def install
    system "make"
    bin.install "osx-cpu-temp"
  end

  test do
    system "#{bin}/osx-cpu-temp"
  end
end
