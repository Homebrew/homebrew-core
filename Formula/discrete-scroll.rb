class DiscreteScroll < Formula
  desc "Fix for OS X's scroll wheel problem"
  homepage "https://github.com/emreyolcu/discrete-scroll"
  url "https://github.com/emreyolcu/discrete-scroll/archive/v0.1.1.tar.gz"
  sha256 "74c94ae4dca1f21a2045fb0700a0ce0e315cf056dea8c7e320a4fc6978c79b03"
  license "MIT"
  head "https://github.com/emreyolcu/discrete-scroll.git"

  def install
    system ENV.cc, "-std=c99", "-O3", "-Wall", "-framework", "Cocoa",
                   "-o", "discrete-scroll", buildpath/"DiscreteScroll/main.m"
    bin.install "discrete-scroll" => "discretescroll"
  end

  test do
    system "exit"
  end
end
