class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.7.0/OpenCoarrays-2.7.0.tar.gz"
  sha256 "cd0288c4d39b2b5c7a6c4213986302ae7f6548b6328de10b577000f023e40f02"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "01185034ea1b104f825a839de5df5a77d9d26c88053e59d66fd30043774c5ff2" => :mojave
    sha256 "2de3af72fc7c073c2a8f11644279b5edfa9f67ac7a60ecae43029dd9afb47751" => :high_sierra
    sha256 "d639b4a968e7fc249fdd905e5ac21542b8427874617d92c59085f5d4c50165e9" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"tally.f90").write <<~EOS
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally/=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}/caf", "tally.f90", "-o", "tally"
    system "#{bin}/cafrun", "-np", "3", "--oversubscribe", "./tally"
  end
end
