class lgtm < Formula
	desc "A simple tool for copying LGTM fancy text to your clipboard.
	homepage "https://github.com/gozeloglu/lgtm"
	url "https://github.com/gozeloglu/lgtm/releases/latest/download/lgtm-mac.tar.gz"
	sha256 "34542797b1e30695601fef0f530d4ef208d36985e323615c6c501a844a917932"
	license "MIT"
	version "0.3.0"

	def install
		bin.install "lgtm"
	end
end
