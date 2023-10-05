class bip39-xor < Formula
  
  desc "Encrypt or decrypt 12, 15, 18, 21 or 24 BIP39 codewords array (so-called "seed phrase") using exclusive OR (XOR)/Vernam cipher (a.k.a. One Time Pad)."
  homepage "https://github.com/GregTonoski/BIP39-XOR"
  url "https://github.com/GregTonoski/BIP39-XOR/blob/main/BIP39-XOR.bash"
  sha256 "b7f4c585b3ab732e7220fb59c252a645334d0f34069b8ff7c2fe6c95b1968b46"
  license :public_domain

  test do
    assert_match "age age age age age age age age age age age used XOR track turtle shy top rude vanish fuel unique final child camp steak", shell_output("#{bin}/bash -c \"BIP39-XOR.bash time until select then return void float true false case catch depart XOR age age age age age age age age age age age used\")
  end
end
