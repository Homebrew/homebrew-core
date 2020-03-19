class Ddcctl < Formula
  desc "DDC monitor controls (brightness) for Mac OSX command-line"
  homepage "https://github.com/kfix/ddcctl"
  url "https://github.com/kfix/ddcctl/archive/02dcf6c9ae77783f50a9948a829dee6865131ef6.tar.gz"
  version "02dcf6c9ae77783f50a9948a829dee6865131ef6"
  sha256 "e591e14c06b3b8cab2e0b092f8337b60dd6d472c1e2e981352721851fab13085"
  head "https://github.com/kfix/ddcctl"

  def install
    if gpu_vendors.find("amd")
      system "make", "amd"
    elsif gpu_vendors.find("nvidia")
      system "make", "nvidia"
    else
      system "make", "intel"
    end

    bin.mkdir
    cp "ddcctl", "#{bin}/ddcctl"
  end

  test do
    system "ddcctl"
  end

  private

  def gpu_vendors
    @gpu_vendors ||= `system_profiler SPDisplaysDataType | grep -i "Vendor: "`.each_line.map(&:downcase)
                                                                              .map { |s| s.match(/vendor: (\w*)/)[1] }
  end
end
